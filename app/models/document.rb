class Document < ApplicationRecord

  include DocumentUploader::Attachment.new(:document) # adds a `document` virtual attribute

  belongs_to :server

end
