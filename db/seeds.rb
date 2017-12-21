user = User.new(name:  "Admin",
             email: "admin@gmail.com",
             password: "123456",
             password_confirmation: "123456",
             up_count: 0,
             down_count: 0,
             coin: 100,
             is_admin: true,
             )
user.skip_confirmation!
user.save!

15.times do |n|
  name  = Faker::Name.name
  email = "user#{n+1}@gmail.com"
  password = "123456"
  user = User.new(name: name,
               email: email,
               password: password,
               up_count: 0,
               down_count: 0,
               coin: 20,
               password_confirmation: password)
  user.skip_confirmation!
  user.save!
end

users = User.order(:created_at).take(6)
10.times do |n|
  users.each { |user| Friend.create!(
    is_accept: true,
    sender_id: user.id,
    accepter_id: n+1)}
end

users = User.first
25.times do
  style = Faker::Book.genre
   users.categories.create!(style: style)
end

users = User.order(:created_at).take(6)
20.times do |n|
  users.each do |user|
    name_document = Faker::Book.title
    user.documents.create!(
    name_document: name_document,
    category_id: n+1,
    content: "#{name_document}.pdf")
  end
end

users = User.order(:created_at).take(6)
5.times do |n|
  users.each do |user|
    name_document = Faker::Book.title
    user.documents.create!(
    name_document: name_document,
    category_id: n+1,
    content: "#{name_document}.pdf",
    deleted_at: Faker::Date.between(2.months.ago, Date.today),
    is_illegal: 1)
  end
end

10.times do |n|
  CoinValue.create!(cost_per_coin: n*100,
    type_buy: Faker::Bank.name)
end

users = User.order(:created_at).take(10)
users.each do |user|
  10.times do |n|
    user.favorites.create!(document_id: n+1)
    user.history_downloads.create!(document_id: n+1)
    user.history_views.create!(document_id: n+1)
    user.comments.create!(content: Faker::Lorem.sentence(5),
    document_id: n+1,
    is_report: 1)
    user.comments.create!(content: Faker::Lorem.sentence(5),
    document_id: n+1,
    is_report: 0)
    user.comments.create!(content: Faker::Lorem.sentence(5),
    document_id: n+1,
    reply_id: n+1)
  end
end
