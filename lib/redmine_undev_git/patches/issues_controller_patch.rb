require_dependency 'issues_controller'

module RedmineUndevGit
  module Patches
    module IssuesControllerPatch

      def self.prepended(base)
        base.class_eval do

          helper_method :remote_revisions

          # authorize remote_revision after find project and issue
          skip_before_action :authorize, only: [:remove_remote_revision]
          before_action :find_issue, only: [:remove_remote_revision]
          before_action :authorized, only: [:remove_remote_revision]

        end
      end

      def remove_remote_revision
        remote_repo = RemoteRepo.find(params[:remote_repo_id])
        rev         = remote_repo.find_revision(params[:sha]) || raise(ActiveRecord::RecordNotFound)
        if rev.related_issues.include?(@issue)
          rev.related_issues.delete(@issue)
          flash[:notice] = l(:notice_successful_update)
        end
        redirect_to action: 'show'
      rescue ActiveRecord::RecordNotFound
        render_404
      end

      private

      def remote_revisions
        @remote_revisions ||=
          User.current.allowed_to?(:view_changesets, @issue.project) ? @issue.remote_revisions.all : nil
      end

    end
  end
end
