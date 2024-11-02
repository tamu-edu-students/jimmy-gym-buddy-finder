# app/services/user_match_action_service.rb
class UserMatchActionService
    def self.perform(action, user, prospective_user)
      new(action, user, prospective_user).perform
    end
  
    def initialize(action, user, prospective_user)
      @action = action
      @user = user
      @prospective_user = prospective_user
    end
  
    def perform
      return { error: "You cannot #{@action} yourself.", status: :unprocessable_entity } if @user.id == @prospective_user.id
  
      user_match = UserMatch.find_or_initialize_by(user_id: @user.id, prospective_user_id: @prospective_user.id)
      user_match.status = past_tense(@action)
  
      if user_match.save
        check_reciprocal_match(user_match) if @action == "match"
        { message: "#{past_tense(@action).capitalize} successfully.", status: :ok }
      else
        { error: "Failed to #{@action}.", status: :unprocessable_entity }
      end
    end
  
    private
  
    def past_tense(verb)
      case verb
      when 'skip' then 'skipped'
      when 'match' then 'matched'
      when 'block' then 'blocked'
      else verb + 'ed'
      end
    end
  
    def check_reciprocal_match(user_match)
      reciprocal_match = UserMatch.find_by(user_id: @prospective_user.id, prospective_user_id: @user.id, status: "matched")
      if reciprocal_match
        Notification.create(user: @user, matched_user: @prospective_user, read: false)
        Notification.create(user: @prospective_user, matched_user: @user, read: false)
      end
    end
  end