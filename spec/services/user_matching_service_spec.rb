# require 'rails_helper'

# RSpec.describe UserMatchingService do
#   let(:user) { create(:user) }
#   let(:service) { described_class.new(user) }

#   describe '#fetch_prospective_users' do
#     let(:new_match) { create(:user_match, user: user, status: 'new') }
#     let(:skipped_match) { create(:user_match, user: user, status: 'skipped') }
#     let(:new_user) { new_match.prospective_user }
#     let(:skipped_user) { skipped_match.prospective_user }

#     before do
#       new_match
#       skipped_match
#       allow(UserFilteringService).to receive_message_chain(:new, :filter_prospective_users).and_return([new_user, skipped_user])
#     end

#     it 'returns an array of prospective users' do
#       result = service.fetch_prospective_users
#       expect(result).to be_an(Array)
#       expect(result.length).to eq(2)
#     end

#     it 'includes both new and skipped matches' do
#       result = service.fetch_prospective_users
#       expect(result.map { |u| u['id'] }).to contain_exactly(new_user.id, skipped_user.id)
#     end

#     it 'orders users correctly (new first, then skipped)' do
#       result = service.fetch_prospective_users
#       expect(result.first['id']).to eq(new_user.id)
#       expect(result.last['id']).to eq(skipped_user.id)
#     end

#     it 'includes basic user data' do
#       result = service.fetch_prospective_users.first
#       expect(result).to include('id', 'username', 'email', 'age', 'gender')
#     end

#     context 'when user has a fitness profile' do
#       before do
#         create(:fitness_profile, user: new_user)
#       end

#       it 'includes fitness profile data' do
#         result = service.fetch_prospective_users.first
#         expect(result).to include('fitness_profile')
#         expect(result['fitness_profile']).to include('activities_with_experience', 'gym_locations', 'workout_schedule', 'workout_types')
#       end
#     end

#     context 'when user does not have a fitness profile' do
#       it 'does not include fitness profile data' do
#         result = service.fetch_prospective_users.first
#         expect(result).not_to include('fitness_profile')
#       end
#     end
#   end

#   describe 'private methods' do
#     describe '#fetch_prospective_user_ids' do
#       it 'returns an array of user ids' do
#         create(:user_match, user: user, status: 'new')
#         create(:user_match, user: user, status: 'skipped')
#         expect(service.send(:fetch_prospective_user_ids)).to be_an(Array)
#         expect(service.send(:fetch_prospective_user_ids).length).to eq(2)
#       end
#     end

#     describe '#fetch_and_filter_user_data' do
#       let(:ordered_ids) { [1, 2, 3] }
#       let(:filtering_service) { instance_double(UserFilteringService) }

#       before do
#         allow(UserFilteringService).to receive(:new).and_return(filtering_service)
#         allow(filtering_service).to receive(:filter_prospective_users).and_return([])
#       end

#       it 'calls UserFilteringService' do
#         expect(filtering_service).to receive(:filter_prospective_users)
#         service.send(:fetch_and_filter_user_data, ordered_ids)
#       end
#     end

#     describe '#organize_user_response' do
#       let(:filtered_users) { create_list(:user, 2) }
#       let(:ordered_ids) { filtered_users.map(&:id) }

#       it 'returns an array of user data' do
#         result = service.send(:organize_user_response, filtered_users, ordered_ids)
#         expect(result).to be_an(Array)
#         expect(result.length).to eq(2)
#         expect(result.first).to include('id', 'username', 'email', 'age', 'gender')
#       end
#     end

#     describe '#add_fitness_profile_data' do
#       let(:user_with_profile) { create(:user) }
#       let(:user_data) { { 'id' => user_with_profile.id } }

#       before do
#         create(:fitness_profile, user: user_with_profile)
#       end

#       it 'adds fitness profile data to user data' do
#         service.send(:add_fitness_profile_data, user_data, user_with_profile)
#         expect(user_data).to include('fitness_profile')
#         expect(user_data['fitness_profile']).to include('activities_with_experience', 'gym_locations', 'workout_schedule', 'workout_types')
#       end
#     end
#   end
# end'
