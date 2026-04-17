puts "🌱 Seeding data..."

# 🧹 Clean old data (optional)
Payment.destroy_all
Lease.destroy_all
Unit.destroy_all
Tenant.destroy_all
User.destroy_all

# 👑 CREATE OWNERS
owner1 = User.create!(
  email: "owner1@test.com",
  password: "password123",
  role: :owner,
  confirmed_at: Time.current
)

owner2 = User.create!(
  email: "owner2@test.com",
  password: "password123",
  role: :owner,
  confirmed_at: Time.current
)

puts "👑 Owners created"

# 🏠 CREATE UNITS FOR OWNERS
units_owner1 = 5.times.map do |i|
  Unit.create!(
    name: "Owner1-Flat-#{i+1}",
    rent_amount: rand(8000..15000),
    status: "vacant",
    owner: owner1
  )
end

units_owner2 = 5.times.map do |i|
  Unit.create!(
    name: "Owner2-Flat-#{i+1}",
    rent_amount: rand(9000..18000),
    status: "vacant",
    owner: owner2
  )
end

puts "🏢 Units created"

# 👤 CREATE TENANTS + USERS
tenants_owner1 = 5.times.map do |i|
  user = User.create!(
    email: "tenant#{i+1}@test.com",
    password: "password123",
    role: :tenant,
    confirmed_at: Time.current
  )

  Tenant.create!(
    name: "Tenant #{i+1}",
    email: user.email,
    user: user,
    owner: owner1
  )
end

tenants_owner2 = 5.times.map do |i|
  user = User.create!(
    email: "tenant#{i+6}@test.com",
    password: "password123",
    role: :tenant,
    confirmed_at: Time.current
  )

  Tenant.create!(
    name: "Tenant #{i+6}",
    email: user.email,
    user: user,
    owner: owner2
  )
end

puts "👥 Tenants created"

# 📄 CREATE LEASES (connect tenants to units)
tenants_owner1.each_with_index do |tenant, i|
  Lease.create!(
    tenant: tenant,
    unit: units_owner1[i],
    start_date: Date.today - 10,
    due_date: Date.today + rand(-5..5),
    rent_amount: units_owner1[i].rent_amount
  )
end

tenants_owner2.each_with_index do |tenant, i|
  Lease.create!(
    tenant: tenant,
    unit: units_owner2[i],
    start_date: Date.today - 15,
    due_date: Date.today + rand(-5..5),
    rent_amount: units_owner2[i].rent_amount
  )
end

puts "📑 Leases created"

puts "✅ Seeding completed!"