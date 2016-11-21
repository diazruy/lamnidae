ActiveAdmin.register IntegrationKey do
  menu parent: 'User'
  belongs_to :user, parent_class: User

  index do
    column :source
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :source, collection: [:insightly]
      f.input :key
    end
    f.actions
  end

  show do
    attributes_table do
      row :source
      row :key
      row :created_at
    end
  end
end
