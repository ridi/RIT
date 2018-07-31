require 'sinatra/session'
require 'sinatra/paginate'
require 'csv'

module Ridiquiz
  Struct.new('Result', :total, :size, :records)

  class WebApp
    register Sinatra::Session
    register Sinatra::Paginate

    enable :sessions
    set :session_fail, '/admin/auth'
    set :session_name, 'RIT'
    set :sessions, :expire_after => 1800

    @@admin_password = ENV['ADMIN_PASSWORD'] || 'admin'

    helpers do
      def page
        [params[:page].to_i - 1, 0].max
      end
    end

    def redirect_to_main
      redirect '/admin', 302
    end    

    get '/admin/auth' do
      redirect_to_main if session?
      haml :'admin/auth'
    end

    post '/admin/auth' do
      if params[:password] == @@admin_password
        session_start!
        redirect_to_main
      else
        session_end!
        redirect back
      end
    end

    get '/admin/logout' do
      session_end!
      redirect_to_main
    end    

    get '/admin' do
      redirect '/admin/records', 301
    end

    before '/admin/*' do |nav|
      @nav = nav.split('/').first
    end

    get '/admin/questions/?:set_id?' do
      session!
      @question_sets = QuestionSet.all
      @question_set = @question_sets.get(params[:set_id])
      if @question_set.nil?
        redirect "/admin/questions/#{@question_sets.first.id}", 302
      else
        @category_sum = {}
        @total_sum = 0
        @question_set.questions.each do |question|
          key = question.category.name
          @category_sum[key] = 0 unless @category_sum.has_key? key
          @category_sum[key] += question.weight
          @total_sum += question.weight
        end
        haml :'admin/questions'
      end
    end

    get '/admin/question/:id' do
      session!
      @question = Question.get(params[:id])
      if @question.nil?
        halt(404, 'Not Found')
      else
        @categories = Category.all
        haml :'admin/question'
      end
    end

    post '/admin/question/:id' do
      session!
      question = Question.get(params[:id])
      if question.nil?
        redirect '/admin/questions', 302
        return
      end
      
      question.choices.each do |choice|
        choice.update(:contents => params["choice-#{choice.id}"])
      end

      question.attributes = {
        :category_id => params[:category_id],
        :contents => params[:contents],
        :solution_id => params[:solution_id],
        :weight => params[:weight]
      }

      if params[:reset_count] == 'true'
        question.hit_count = question.correct_count = 0
      end

      question.save

      redirect "/admin/questions/#{question.question_set.id}", 302
    end

    get '/admin/records' do
      session!
      @categories = Category.all
      records = Record.all(:order => [:created_at.desc], :offset => page * 20, :limit => 20)
      @result = Struct::Result.new(Record.count, records.count, records)

      haml :'admin/records'
    end

    get '/admin/records/csv' do
      content_type 'application/csv'
      attachment   'records.csv'

      session!
      @categories = Category.all
      records = Record.all(:order => [:created_at.desc])

      CSV.generate(headers: true) do |csv|
        csv << ['이름', '지원 분야', '리디북스 ID', '일시', '문제 유형', @categories.map { |c| c.name }, '총점'].flatten
        records.each { |record|
          csv <<
          [
            record.name,
            record.applied_dept,
            record.ridibooks_id,
            record.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            record.question_set.name,
            @categories.map { |c| record.score_for_category(c).to_i },
            record.score.to_i,
          ].flatten
        }
      end
    end
  end
end
