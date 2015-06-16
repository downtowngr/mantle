Sequel.migration do
  change do
    create_table(:mantle_settings) do
      primary_key :id
      String :key, index: true, unique: true
      String :value
    end
  end
end
