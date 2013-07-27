namespace :mamajamas do

  namespace :reports do

    namespace :quiz do

      desc "a basic report of quiz answers"
      task answers: :environment do

        puts
        questions = %w(feeding diapering sleeping travel caution)
        User.scoped.each do |user|
          answers = user.quiz_answers
          if user.quiz_answers.count > 0
            answers = Hash.new { |h, k| h[k] = [] }
            user.quiz_answers.each do |answer|
              answers[answer.question] = answer.answers
            end

            puts user.username
            puts "-------------------"
            questions.each do |question|
              puts "#{question}: #{answers[question].join(', ')}"
            end
            puts
            puts
          end
        end

      end

    end

  end
end
