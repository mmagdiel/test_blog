class PostReportMailer < ApplicationMailer

  def post_report(user, post, report)
    @post = post
    mail to: user.email, subject: "Post #{post.id} report"
  end
end
