Sequel.migration do 
  change do

    create_table :visits do
      primary_key :id
      String    :url
      String    :referrer
      DateTime  :created_at
      String    :hash
      index [:url, :referrer, :created_at]
    end

  end
end