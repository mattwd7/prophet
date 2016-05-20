Organization.create!([
   {name: "Prophet LLC"}
])
User.create!(title: "Founder", email: "seb@symbiotic.com", type: "Admin", first_name: "Sebastian" , last_name: "Cardoso", password: "password", password_confirmation: "password", organization_id: 1)
User.create!(title: "Engineer", email: "engineer1@symbiotic.com", type: "", first_name: "Engineer" , last_name: "One", password: "password", password_confirmation: "password", organization_id: 1)
User.create!(title: "Engineer", email: "engineer2@symbiotic.com", type: "", first_name: "Engineer" , last_name: "Two", password: "password", password_confirmation: "password", organization_id: 1)
User.create!(title: "Engineer", email: "engineer3@symbiotic.com", type: "", first_name: "Paul" , last_name: "Bellezza", password: "password", password_confirmation: "password", organization_id: 1)
User.create!(title: "Artist", email: "artist@symbiotic.com", type: "", first_name: "Robin" , last_name: "Mayne", password: "password", password_confirmation: "password", organization_id: 1)
User.create!(title: "Designer", email: "designer@symbiotic.com", type: "", first_name: "Thomas" , last_name: "Vu", password: "password", password_confirmation: "password", organization_id: 1)