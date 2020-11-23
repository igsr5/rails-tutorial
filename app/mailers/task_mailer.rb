class TaskMailer < ApplicationMailer
  default from: 'taskleaf@example.com'
  def creation_email(task)
    @task=task
    mail(
        subject: 'タスク作成完了メール',
        to: 'sora1220.119014@outlook.jp',
        from: 'taskleaf@example.com'
    )


  end
end
