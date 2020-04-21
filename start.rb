require_relative 'near_earth_objects'

class NearEarthObjectsDisplay < NearEarthObjects

  def self.start
    intro_dashboard
    @@date ||= gets.chomp
    @@asteroid_info ||= NearEarthObjects.find_neos_by_date(@@date)
    return_dashboard
  end

  private

  def self.intro_dashboard
    puts "________________________________________________________________________________________________________________________________"
    puts "Welcome to NEO. Here you will find information about how many meteors, astroids, comets pass by the earth every day. \nEnter a date below to get a list of the objects that have passed by the earth on that day."
    puts "Please enter a date in the following format YYYY-MM-DD."
    print ">>"
  end

  def self.column_labels
    { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }
  end

  def self.column_data
    column_labels.each_with_object({}) do |(col, label), hash|
      hash[col] = {
        label: label,
        width: [@@asteroid_info[:astroid_list].map { |astroid| astroid[col].size }.max, label.size].max}
    end
  end

  def self.header
    "| #{ column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
  end

  def self.divider
    "+-#{column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"
  end

  def self.format_row_data(row_data, column_info)
    row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
    puts "| #{row} |"
  end

  def self.create_rows(astroid_data, column_info)
    astroid_data.each { |astroid| format_row_data(astroid, column_info) }
  end

  def self.formated_date
    DateTime.parse(@@date).strftime("%A %b %d, %Y")
  end

  def self.return_dashboard_text
    puts "______________________________________________________________________________"
    puts "On #{formated_date}, there were #{@@asteroid_info[:total_number_of_astroids]} objects that almost collided with the earth."
    puts "The largest of these was #{@@asteroid_info[:biggest_astroid]} ft. in diameter."
    puts "\nHere is a list of objects with details:"
  end

  def self.return_dashboard_table
    puts divider
    puts header
    create_rows(@@asteroid_info[:astroid_list], column_data)
    puts divider
  end

  def self.return_dashboard
    return_dashboard_text
    return_dashboard_table
  end

end

NearEarthObjectsDisplay.start
