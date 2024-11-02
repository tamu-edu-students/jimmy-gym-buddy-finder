module Helpers
    def parse_prospective_users_response(page)
      # Assuming the controller sets an instance variable @prospective_users
      # which is then rendered in some form in the response
      if page.body.include?('prospective_users')
        # This is a very basic parsing. Adjust according to actual output
        eval(page.body.match(/@prospective_users = (\[.*?\])/m)[1])
      else
        []
      end
    end
  end
  
  World(Helpers)