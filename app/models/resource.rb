class Resource < ApplicationRecord
	mount_uploader :uploads, AttachmentUploader # Tells rails to use this uploader for this model.
end
