class DeviseInvitableAddToCompanies < ActiveRecord::Migration[6.0]
  def up
    change_table :companies do |t|
    end
  end

  def down
    change_table :companies do |t|
      t.remove_references :invited_by, polymorphic: true
      t.remove :invitations_count, :invitation_limit, :invitation_sent_at, :invitation_accepted_at, :invitation_token, :invitation_created_at
    end
  end
end
