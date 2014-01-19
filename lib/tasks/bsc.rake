require 'rubygems'
require 'nokogiri'
require 'open-uri'

namespace :spree_bsc do
  desc 'Loads BSC stock data' 
  task :load => :environment do

    #SpreeSample::Engine.load_samples

    puts "\nCurrent Spree Products"
    puts "----------------------"
    products = Spree::Product.find(:all)
    products.each do |product|
      puts product.name
    end
    puts
    
    #abort("\nWTF???\n\n")
    # ----------------------------------------
    
    domain = "www.pongees.co.uk"
    path = "/fabrics/interiors/productcatalogue/690"
    
    total = 0
    next_page = nil
    begin
      unless next_page.nil?
        #puts "Nokogiri next_page class: " + next_page.class.to_s 
        path = next_page[0]["href"]
      end
      
      page = Nokogiri::HTML(open("http://#{domain}#{path}"))
    
      silk_names = page.css('div.views-field-field-product-colour a')
      silk_codes = page.css('div.views-field-field-product-code a')
      
      puts "--- START ---"
      # The number of products is the size of the 'silk_names' array
      puts silk_names.length
      total += silk_names.length
      
      products.each do |product|
      
        # Uses 'find' from the Ruby Enumerable mixin (since 'silk_names' is a 'Nokogiri::XML::NodeSet' which is an array)
        if silk_names.find{ |node| node.text =~ /#{product.name.upcase}/ }
#debugger
          puts "Found " + product.name
        end
      end
      
=begin
      while !silk_names.empty?
        puts silk_names.shift.text
        puts silk_codes.shift.text
      end
=end
      
      puts "=== END ==="      
      
    end while !(next_page = page.css('div.item-list ul.pager li.pager-next a')).empty?
    
    puts "TOTAL: " + total.to_s
    
    # -----------------------
=begin
    page.css('table.views-view-grid tr td div.views-field-field-product-colour a').each do |el|
    
    page.css('div.taxonomy_colours_titles a').each do |silk_name|
      puts "--------"
      puts "'" + silk_name.text + "'"
      puts "========"
    end

    silk_anchors = page.css('div.taxonomy_colours_titles a')
  
    puts silk_anchors.length
    puts silk_anchors.class
    
    puts silk_anchors[0].text
    puts silk_anchors[0]["href"]
    puts silk_anchors[0].to_s
    
    puts silk_anchors[1].text
    puts silk_anchors[1]["href"]
=end

  end
end