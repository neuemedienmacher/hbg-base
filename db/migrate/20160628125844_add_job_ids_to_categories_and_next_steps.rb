class AddJobIdsToCategoriesAndNextSteps < ActiveRecord::Migration
  def change
    add_column :next_steps, :job_id_pl, :integer, null: true, default: nil
    add_column :next_steps, :job_id_ru, :integer, null: true, default: nil
    add_column :next_steps, :job_id_ar, :integer, null: true, default: nil
    add_column :next_steps, :job_id_tr, :integer, null: true, default: nil
    add_column :next_steps, :job_id_fr, :integer, null: true, default: nil

    add_column :categories, :job_id_pl, :integer, null: true, default: nil
    add_column :categories, :job_id_ru, :integer, null: true, default: nil
    add_column :categories, :job_id_ar, :integer, null: true, default: nil
    add_column :categories, :job_id_tr, :integer, null: true, default: nil
    add_column :categories, :job_id_fr, :integer, null: true, default: nil
  end
end
