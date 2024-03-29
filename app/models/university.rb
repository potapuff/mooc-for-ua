class University

  class << self
    attr_accessor :table_gid
    attr_accessor :database
    @@holder = nil
  end

  def self.all
    i = 0
    data_full, data_part = [],[]
    auth.rows.each do |row|
      next if (i+=1) == 1
      data_full <<
        {
        :id => row[0].to_i,
        :domain => row[2].filtrate.my_split(/[,;]/),
        :UA => row[3],
        :EN => row[4],
        :URL => row[5],
        :admin => row[6].filtrate.my_split(/[,;]/)
        }
      data_part << {
        :id => row[0].to_i,
        :UA => row[3],
        :EN => row[4],
      }
    end
    {full: data_full.index_by{|x| x[:id]}, part: data_part}
  end

  extend CachedModel

  private

  def self.auth
    session = GoogleDrive::Session.from_service_account_key("config/key.json")
    spreadsheet = session.spreadsheet_by_key(database)
    spreadsheet.worksheet_by_gid(table_gid)
  end

end
