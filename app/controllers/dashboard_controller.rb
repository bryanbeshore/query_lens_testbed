class DashboardController < ApplicationController
  def index
    @user_count = User.count
    @admin_count = User.admin.count
    @team_count = Team.count
    @teams_by_plan = Team.group(:plan).count
    @post_count = Post.count
    @posts_by_status = Post.group(:status).count
    @comment_count = Comment.count
    @tag_count = Tag.count
    @invoice_count = Invoice.count
    @invoices_by_status = Invoice.group(:status).count
    @total_revenue = Invoice.paid.sum(:amount)
    @outstanding = Invoice.where(status: [:pending, :overdue]).sum(:amount)
    @recent_posts = Post.includes(:user, :team).order(created_at: :desc).limit(10)
    @top_commenters = User.joins(:comments).group("users.id", "users.name").order("count_all DESC").limit(5).count
    @top_teams = Team.joins(:posts).group("teams.id", "teams.name").order("count_all DESC").limit(5).count
  end
end
