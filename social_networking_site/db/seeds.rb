# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

# MHK
# Clear the database
Member.destroy_all

# MHK
# Create 6 Member objects and set up Friendship connections with the
# following adjacency matrix shown on Member id:
#
#    1 2 3 4 5 6
#    -----------
# 1| 0 1 0 1 0 0
# 2| 1 0 1 1 0 0
# 3| 0 1 0 0 0 0 
# 4| 1 1 0 0 0 0 
# 5| 0 0 0 0 0 1
# 6| 0 0 0 0 1 0
john = Member.create(
  full_name: 'John Doe',
  website: 'https://en.wikipedia.org/wiki/Gold'
)
jane = Member.create(
  full_name: 'Jane Doe',
  website: 'https://en.wikipedia.org/wiki/Silver'
)
joe = Member.create(
  full_name: 'Joe Bloggs',
  website: 'https://en.wikipedia.org/wiki/Platinum'
)
janet = Member.create(
  full_name: 'Janet Bloggs',
  website: 'https://en.wikipedia.org/wiki/Palladium'
)
jason = Member.create(
  full_name: 'Jason Smith',
  website: 'https://en.wikipedia.org/wiki/Iron'
)
jenny = Member.create(
  full_name: 'Jenny Smith',
  website: 'https://en.wikipedia.org/wiki/Nickel'
)

john.friendships.create(
  friend_member_id: jane.id
)
jane.friendships.create(
  friend_member_id: joe.id
)
janet.friendships.create(
  friend_member_id: john.id
)
janet.friendships.create(
  friend_member_id: jane.id
)
jason.friendships.create(
  friend_member_id: jenny.id
)
