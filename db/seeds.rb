# Destroy all existing users (optional, use with caution)
User.destroy_all

# Create admin users
User.create!([
  { email: 'a1@google.com', password: 'your_password', role: :admin },
  { email: 'a2@google.com', password: 'your_password', role: :admin }
])

# Create librarian users
User.create!([
  { email: 'l1@google.com', password: 'your_password', role: :librarian },
  { email: 'l2@google.com', password: 'your_password', role: :librarian },
  { email: 'l3@google.com', password: 'your_password', role: :librarian },
  { email: 'l4@google.com', password: 'your_password', role: :librarian },
  { email: 'l5@google.com', password: 'your_password', role: :librarian }
])

puts "Created #{User.where(role: :admin).count} admin users"
puts "Created #{User.where(role: :librarian).count} librarian users"