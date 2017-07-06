module Ridiquiz
  class WebApp
    get '/' do
      @question_sets = QuestionSet.all
      @message = flash[:message]
      haml :start
    end

    post '/' do
      test_info = {}
      test_info[:name] = params[:name]
      test_info[:applied_dept] = params[:applied_dept]
      test_info[:ridibooks_id] = params[:ridibooks_id]
      if params[:question_set] == 'random'
        test_info[:question_set] = QuestionSet.all.sample
      else
        test_info[:question_set] = QuestionSet.get(params[:question_set])
      end

      flash[:test_info] = test_info
      redirect '/test', 302
    end

    get '/test' do
      test_info = flash[:test_info]
      error 400 if test_info.nil?
      @name = test_info[:name]
      @applied_dept = test_info[:applied_dept]
      @ridibooks_id = test_info[:ridibooks_id]
      @question_set = test_info[:question_set]
      @questions = @question_set.questions
      haml :test
    end

    post '/test' do
      question_set = QuestionSet.get(params[:question_set])

      record = Record.new(
        :name => params[:name],
        :applied_dept => params[:applied_dept],
        :ridibooks_id => params[:ridibooks_id],
        :score => 0,
        :question_set => question_set,
        :created_at => Time.now
      )
      
      question_set.questions.each do |question|
        choice_id = params['answer-' + question.id.to_s]
        choice = Choice.get(choice_id)

        correctness = (not choice.nil? and question.solution_id == choice.id)

        RecordScore.create(
          :answer => choice.nil? ? '' : choice.contents,
          :correctness => correctness,
          :record => record,
          :question => question
        )

        correct_count = question.correct_count
        if correctness
          record.score += question.weight
          correct_count += 1
        end
        question.update(
            :hit_count => question.hit_count + 1,
            :correct_count => correct_count)
      end

      record.save
      flash[:message] = '성공적으로 제출하였습니다.'
      redirect '/', 302
    end
  end
end
