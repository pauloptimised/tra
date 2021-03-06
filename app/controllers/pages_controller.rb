class PagesController < ApplicationController
  before_action :set_page

  def show
    return redirect_to @page, status: :moved_permanently if request.path != page_path(@page)
    render layout: @page.layout
  end

  private

    def set_page
      @page = Page.displayed.friendly.find(params[:id])
      @presented_page = PagePresenter.new(object: @page, view_template: view_context)
      @presented_interests = present_collection(Interest.displayed) if @page.sidebar == 'interests'
      @presented_articles = present_collection(Article.displayed.limit(3)) if @page.sidebar == 'articles'
    end
end
