class AboutController < ApplicationController
    skip_filter :require_login
    def help
    end
    def index
    end
    def download_pdf
        send_file(
          "#{Rails.root}/public/abc.pdf",
          filename: "abc.pdf",
          type: "application/pdf"
        )
    end
end