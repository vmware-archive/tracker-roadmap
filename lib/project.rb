class Project < Model
  self.site = v5
  has_many :epics
  has_many :stories
  has_many :integrations
end