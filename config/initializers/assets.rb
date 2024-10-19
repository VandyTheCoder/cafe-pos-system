Rails.application.config.assets.version = "1.0"

Rails.application.config.assets.precompile += %w[ application.css ]
Rails.application.config.assets.precompile += %w[ devise.css ]
Rails.application.config.assets.precompile += %w[ pdf.css ]

Rails.application.config.assets.precompile += %w[ application.js ]
Rails.application.config.assets.precompile += %w[ devise.js ]
