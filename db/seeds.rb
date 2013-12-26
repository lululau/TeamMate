# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Person.create :name => 'admin',
            :email => 'team_mates@163.com',
            # 默认口令为 12345678
            :encrypted_password => '$2a$10$HfO/Pju/AlD/lYiM6XinJeI0Wp5auCm59kupuEs3ICHbPYfO8aYTC',
            :role => 'admin',
            :avatar => 0,
            :locked => false

