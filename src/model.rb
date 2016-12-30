require 'dm-core'
require 'dm-migrations'

module Ridiquiz
  DataMapper.setup :default, ENV['DATABASE_URL'] || "sqlite:///#{WebApp::root}/database"

  DataMapper.repository(:default).adapter.resource_naming_convention = 
    DataMapper::NamingConventions::Resource::UnderscoredAndPluralizedWithoutModule

  class Category
    include DataMapper::Resource

    property :id,   Serial
    property :name, Text, :required => true

    has n, :questions
  end

  class QuestionSet
    include DataMapper::Resource

    property :id,         Serial
    property :name,       Text, :required => true
    property :created_at, DateTime, :required => true

    has n, :questions
    has n, :records
  end

  class Choice
    include DataMapper::Resource

    property :id,        Serial
    property :contents,  Text, :required => true

    belongs_to :question
  end

  class Question
    include DataMapper::Resource

    property :id,             Serial
    property :contents,       Text, :required => true
    property :solution_id,    Integer, :required => true
    property :weight,         Float, :required => true
    property :hit_count,      Integer, :required => true
    property :correct_count,  Integer, :required => true
    property :created_at,     DateTime, :required => true

    has n, :choices
    has n, :record_scores
    belongs_to :category
    belongs_to :question_set

    def correction_rate()
      if hit_count == 0
        'N/A'
      else
        '%.2f' % (correct_count.to_f / hit_count * 100)
      end
    end
  end

  class Record
    include DataMapper::Resource

    property :id,           Serial
    property :name,         Text, :required => true
    property :applied_dept, Text, :required => true
    property :ridibooks_id, Text
    property :memo,         Text
    property :score,        Float, :required => true
    property :created_at,   DateTime, :required => true

    has n, :record_scores
    belongs_to :question_set

    def score_for_category(category)
      sum = 0
      scores = record_scores.select { |s| s.correctness and s.question.category == category }
      scores.each do |s|
        sum += s.question.weight
      end
      sum
    end
  end

  class RecordScore
    include DataMapper::Resource

    property :id,           Serial
    property :answer,       Text, :required => true
    property :correctness,  Boolean, :required => true

    belongs_to :record
    belongs_to :question
  end

  DataMapper.finalize.auto_upgrade!
end
