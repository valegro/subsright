xml.instruct!
xml.user do
  xml.id @user.id
  xml.name @user.name
  xml.email @user.email
  xml.time_zone @user.time_zone
  xml.currency @user.currency
  xml.created_at @user.created_at
  xml.updated_at @user.updated_at
end
