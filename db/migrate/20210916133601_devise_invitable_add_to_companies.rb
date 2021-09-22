class DeviseInvitableAddToCompanies < ActiveRecord::Migration[6.0]
  def up
    change_table :companies do |t|
      t.string     :invitation_token
      t.datetime   :invitation_created_at
      t.datetime   :invitation_sent_at
      t.datetime   :invitation_accepted_at
      t.integer    :invitation_limit
      t.references :invited_by, polymorphic: true
      # 何人のユーザーを招待したか（招待されて登録した数ではなく、招待メールを送信した人数）
      t.integer    :invitations_count, default: 0
      t.index      :invitation_token, unique: true # for invitable
      # どのユーザーによって招待されたか
      t.index      :invited_by_id
    end
  end

  def down
    change_table :companies do |t|
      t.remove_references :invited_by, polymorphic: true
      t.remove :invitations_count, :invitation_limit, :invitation_sent_at, :invitation_accepted_at, :invitation_token, :invitation_created_at
    end
  end
end
