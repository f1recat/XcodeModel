module XcodeModel
  class XcodeModelController < ::ApplicationController
    def index
      render text:params[:model]
    end
  end
end