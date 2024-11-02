# app/services/matching_service.rb
class MatchingService
    def self.perform_action(action, user, prospective_user)
      return { error: "You cannot #{action} yourself.", status: :unprocessable_entity } if user.id == prospective_user.id
  
      user_match = UserMatch.find_or_initialize_by(user_id: user.id, prospective_user_id: prospective_user.id)
      user_match.status = past_tense(action)
  
      if user_match.save
        { message: "#{past_tense(action).capitalize} successfully.", status: :ok }
      else
        { error: "Failed to #{action}.", status: :unprocessable_entity }
      end
    end
  
    def self.check_reciprocal_match(user, prospective_user)
      reciprocal_match = UserMatch.find_by(user_id: prospective_user.id, prospective_user_id: user.id, status: "matched")
      if reciprocal_match
        Notification.create(user: user, matched_user: prospective_user, read: false)
        Notification.create(user: prospective_user, matched_user: user, read: false)
      end
    end
  
    private
  
    def self.past_tense(verb)
      case verb
      when 'skip' then 'skipped'
      when 'match' then 'matched'
      when 'block' then 'blocked'
      else verb + 'ed'
      end
    end
  end