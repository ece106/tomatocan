class ChangeAgreementProjidToPhaseid < ActiveRecord::Migration[5.0]
  def change
    rename_column :agreements, :project_id, :phase_id
    rename_column :merchandises, :project_id, :phase_id
    rename_column :phases, :projectpic, :phasepic
  end
end