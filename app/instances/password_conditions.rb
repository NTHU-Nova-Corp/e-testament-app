# frozen_string_literal: true

module ETestament
  class PasswordCondition
    def list
      ['A lowercase letter',
       'A capital letter',
       'A number',
       'Minimum 8 characters']
    end
  end
end
