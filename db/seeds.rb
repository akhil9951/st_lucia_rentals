# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# साफ clean old data (optional but useful)
Payment.destroy_all
Lease.destroy_all
Unit.destroy_all
Tenant.destroy_all

puts "🌱 Seeding data..."

# 👤 Tenants
tenants = [
  { name: "Akhil", email: "akhil@test.com", phone: "9999999991" },
  { name: "Ravi", email: "ravi@test.com", phone: "9999999992" },
  { name: "Suresh", email: "suresh@test.com", phone: "9999999993" }
]

tenants = tenants.map { |t| Tenant.create!(t) }

# 🏢 Units
units = [
  { name: "Flat-101", rent_amount: 10000, status: 1 },
  { name: "Flat-102", rent_amount: 12000, status: 1 },
  { name: "Flat-103", rent_amount: 8000, status: 0 }
]

units = units.map { |u| Unit.create!(u) }

# 🔗 Leases
leases = []

leases << Lease.create!(
  tenant: tenants[0],
  unit: units[0],
  start_date: Date.today - 30,
  rent_amount: 10000,
  due_date: Date.today - 5,
  status: 0
)

leases << Lease.create!(
  tenant: tenants[1],
  unit: units[1],
  start_date: Date.today - 20,
  rent_amount: 12000,
  due_date: Date.today + 5,
  status: 0
)

# 💰 Payments
Payment.create!(
  tenant: tenants[0],
  lease: leases[0],
  amount: 6000,
  payment_date: Date.today - 3,
  status: 1,
  transaction_id: "TXN1001"
)

Payment.create!(
  tenant: tenants[0],
  lease: leases[0],
  amount: 4000,
  payment_date: Date.today - 1,
  status: 1,
  transaction_id: "TXN1002"
)

Payment.create!(
  tenant: tenants[1],
  lease: leases[1],
  amount: 5000,
  payment_date: Date.today,
  status: 0, # pending
  transaction_id: "TXN1003"
)

puts "✅ Seeding completed!"