ActiveAdmin.register User do
  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :sign_in_count
      row :last_sign_in_at
      row :created_at
      row :integrations do
        link_to "View", admin_user_integration_keys_path(user)
      end
    end

  end
end
