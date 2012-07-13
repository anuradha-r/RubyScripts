#Converts csv files to plist 

require 'csv'
require 'builder'

class CSVToPlistConverter

  def self.convert_CSV_to_plist(inputFile,outputFileName,plistName)
    csvEntries = read_CSV_from_file(inputFile)
    #plistName = read_title(csvEntries)
    #puts plistName
    csvColumnNames = read_column_names(csvEntries)
    xmlBuilder = create_blank_XMl_file(outputFileName)
    convert_csvEntries_to_plist(csvEntries,csvColumnNames,xmlBuilder,plistName)   
  end 
  
  def self.read_CSV_from_file(csvFile)
    CSV.read(csvFile)
  end
  
  def self.read_title(csvEntries)
     csvEntries.shift
  end
  
  def self.read_column_names(csvEntries)
    columnNames = csvEntries.shift
  end
     
  def self.convert_csvEntries_to_plist(csvEntries,csvColumnNames,xmlBuilder,plistName)
     xmlBuilder.plist do
       xmlBuilder.dict do
         xmlBuilder.key(plistName)
         xmlBuilder.array do
            csvEntries.each do |row|
              xmlBuilder.dict do
                xmlBuilder.key(row[0]) #wt percent
                xmlBuilder.dict do
                  for i in 1..row.length - 1
                    xmlBuilder.key(csvColumnNames[i])
                    xmlBuilder.string(row[i])                
                   end 
                end    
              end
            end 
         end
       end
     end       
  end 
  
  def self.create_blank_XMl_file(outputFileName)
    plistFile = File.new(outputFileName,"w")
    builder = Builder::XmlMarkup.new(:target => plistFile, :indent => 2)
    builder.instruct! :xml, :version =>"1.0", :encoding => "UTF-8"
    builder.declare! :DOCTYPE, :plist, :PUBLIC , "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"
    builder
  end 
    
end 

#The last argument is the key for the contents of the csv file
CSVToPlistConverter.convert_CSV_to_plist("Spotting Fluid.csv", "SpottingFluid.plist","SpottingFluid")

