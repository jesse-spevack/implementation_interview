# 5) Write a Rails script to categorize the cafes and write the result to the category according to the rules:[provide the script]
#     A) If the Post Code is of the LS1 prefix type:
#         # of chairs less than 10: category = 'ls1 small'
#         # of chairs greater than or equal to 10, less than 100: category = 'ls1 medium'
#         # of chairs greater than or equal to 100: category = 'ls1 large'
#     B) If the Post Code is of the LS2 prefix type:
#         # of chairs below the 50th percentile for ls2: category = 'ls2 small'
#         # of chairs above the 50th percentile for ls2: category = 'ls2 large'
#     C) For Post Code is something else:
#         category = 'other'
require 'rails_helper'

RSpec.describe Categorizer do
  it "categorizes shops in postal code LS1 correctly" do
    shop_1 = create(:shop, post_code: "LS1 XXX", chairs: 9)
    shop_2 = create(:shop, post_code: "LS1 XXX", chairs: 10)
    shop_3 = create(:shop, post_code: "LS1 XXX", chairs: 100)

    [shop_1, shop_2, shop_3].each do |shop|
      Categorizer.new(shop).assign_category!
    end

    expect(shop_1.category).to eq("ls1 small")
    expect(shop_2.category).to eq("ls1 medium")
    expect(shop_3.category).to eq("ls1 large")
  end

  it "categorizes shops in postal code LS2 correctly" do
    shop_1 = create(:shop, post_code: "LS2 XXX", chairs: 6)
    shop_2 = create(:shop, post_code: "LS2 XXX", chairs: 18)
    shop_3 = create(:shop, post_code: "LS2 XXX", chairs: 20)
    shop_4 = create(:shop, post_code: "LS2 XXX", chairs: 20)
    shop_5 = create(:shop, post_code: "LS2 XXX", chairs: 20)
    shop_6 = create(:shop, post_code: "LS2 XXX", chairs: 51)
    shop_7 = create(:shop, post_code: "LS2 XXX", chairs: 84)
    shop_8 = create(:shop, post_code: "LS2 XXX", chairs: 96)
    shop_9 = create(:shop, post_code: "LS2 XXX", chairs: 118)
    shop_10 = create(:shop, post_code: "LS2 XXX", chairs: 140)

    list = [shop_1, shop_2, shop_3, shop_4, shop_5, shop_6, shop_7, shop_8,
            shop_9, shop_10]
    list.each do |shop|
      Categorizer.new(shop).assign_category!
    end

    expect(shop_1.category).to eq("ls2 small")
    expect(shop_2.category).to eq("ls2 small")
    expect(shop_3.category).to eq("ls2 small")
    expect(shop_4.category).to eq("ls2 small")
    expect(shop_5.category).to eq("ls2 small")
    expect(shop_6.category).to eq("ls2 large")
    expect(shop_7.category).to eq("ls2 large")
    expect(shop_8.category).to eq("ls2 large")
    expect(shop_9.category).to eq("ls2 large")
    expect(shop_10.category).to eq("ls2 large")
  end

  it "categorizes shops that are in neither LS2 or LS1 correctly" do
    shop = create(:shop, post_code: "LS10 XXX")
    Categorizer.new(shop).assign_category!
    expect(shop.category).to eq("other")
  end
end