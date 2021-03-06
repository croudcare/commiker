module UseCase
  class StatusMatcher
    STATUS_SETTER_REGEX   = /\A[a-zA-Z](.*)!\z/
    STATUS_QUESTION_REGEX = /\A[a-zA-Z](.*)\?\z/

    def initialize(text)
      @text = text
    end

    def match?
      match_as_setter? || match_as_question?
    end

    def match_as_setter?
      !!(@text =~ STATUS_SETTER_REGEX)
    end

    def match_as_question?
      !!(@text =~ STATUS_QUESTION_REGEX)
    end

    def status
      @text[0...-1]
    end
  end
end