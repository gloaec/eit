# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#

# Users 

superadmin = User.create!({
  email:                 "superadmin@nrj.fr", 
  role:                  "superadmin", 
  password:              "superadmin12345", 
  password_confirmation: "superadmin12345" 
})

admin = User.create!({
  email:                 "admin@nrj.fr", 
  role:                  "admin", 
  password:              "admin12345", 
  password_confirmation: "admin12345" 
})

user = User.create!({
  email:                 "user@nrj.fr",
  role:                  "user",
  password:              "user12345",
  password_confirmation: "user12345"
})

contact1 = User.create!({
  email:                 "contact1@nrj.fr",
  role:                  "contact",
  password:              "user12345",
  password_confirmation: "user12345"
})

contact2 = User.create!({
  email:                 "contact2@nrj.fr",
  role:                  "contact",
  password:              "user12345",
  password_confirmation: "user12345"
})


# Channels

channel1 = Channel.create({
  name:         "NRJ Paris",
  queue_path:   "/home/ghis/Workspace/nrj-eit/data/NRJParis/pending",
  error_path:   "/home/ghis/Workspace/nrj-eit/data/NRJParis/error"
})

channel2 = Channel.create({
  name:         "NRJ 12",
  queue_path:   "/home/ghis/Workspace/nrj-eit/data/NRJ12/pending",
  error_path:   "/home/ghis/Workspace/nrj-eit/data/NRJ12/error"
})

channel3 = Channel.create({
  name:         "Chérie 25",
  queue_path:   "/home/ghis/Workspace/nrj-eit/data/Cherie25/pending",
  error_path:   "/home/ghis/Workspace/nrj-eit/data/Cherie25/error"
})


# Ftps

ftp1 = Ftp.create({
  host:            "ftpperso.free.fr",
  port:            21,
  user:            "ghis182",
  password:        "turtoise",
  passive:         false,
})

channel1_ftp1 = ChannelFtp.create(
  channel: channel1,
  ftp: ftp1,
  success_path: "/NRJ"
)

channel2_ftp1 = ChannelFtp.create(
  channel: channel2,
  ftp: ftp1,
  success_path: "/NRJ"
)

channel2_ftp1 = ChannelFtp.create(
  channel: channel3,
  ftp: ftp1,
  success_path: "/NRJ"
)

channel1.admins << admin
channel2.users  << admin
channel3.users  << admin

channel1.users << user
channel2.users << user
channel3.users << user

channel1.contacts << user
channel2.contacts << user
channel3.contacts << user

channel1.contacts << admin 
channel2.contacts << admin 
channel3.contacts << admin 

channel1.contacts << superadmin 
channel2.contacts << superadmin 
channel3.contacts << superadmin 

channel1.contacts << contact1 
channel2.contacts << contact1 
channel3.contacts << contact1 

channel1.contacts << contact2 
channel2.contacts << contact2 
channel3.contacts << contact2 
