# frozen_string_literal: true
class User < ApplicationRecord
  has_many :orders
  has_many :payments
  has_many :notifications
  has_many :reviews
  has_many :addresses
  has_many :wishlists
end
