module MembersHelper
  module Organization

    def addMemberToOrganization
      {
        organization: organization_name,
        user_id: data["idMemberAdded"]
      }
    end

    def addToOrganizationBoard
      {
        organization: organization_name,
        board: data["board"]["name"]
      }
    end

    def createOrganization
      {
        organization: organization_name
      }
    end

    def deleteOrganizationInvitation
    end

    def makeNormalMemberOfOrganization
      {
        organization: organization_name,
        user: participant["fullName"]
      }
    end

    def removeAdminFromOrganization;
    end

    def removeFromOrganizationBoard;
    end

    def updateOrganization
      return updateOrganization_name if data["old"]
      return updateOrganization_website if data["organization"]["website"]
      {
        organization: organization_name,
        type: :updated
      }
    end

    protected

    def updateOrganization_name
      {
        organization: organization_name,
        type: data["old"].keys.first
      }
    end

    def updateOrganization_website
      {
        organization: organization_name,
        type: :set_website
      }
    end

    def unconfirmedOrganizationInvitation;
    end

  end
end
