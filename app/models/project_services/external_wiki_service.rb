# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  title      :string(255)
#  project_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean          default(FALSE), not null
#  properties :text
#

class ExternalWikiService < Service
  include HTTParty

  prop_accessor :external_wiki_url
  validates :external_wiki_url,
            presence: true,
            format: { with: URI::regexp },
            if: :activated?

  def title
    'External Wiki'
  end

  def description
    'Replaces the link to the internal wiki with a link to an external wiki.'
  end

  def to_param
    'external_wiki'
  end

  def fields
    [
      { type: 'text', name: 'external_wiki_url', placeholder: 'The URL of the external Wiki' },
    ]
  end

  def execute(_data)
    @response = HTTParty.get(properties['external_wiki_url'], verify: true) rescue nil
    if @response !=200
      nil
    end
  end
end
