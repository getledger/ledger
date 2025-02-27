import path from 'path';
import { ISystemUser } from '@/interfaces';
import Mail from '@/lib/Mail';
import { Service } from 'typedi';
import { Tenant } from '@/system/models';
import config from '@/config';

@Service()
export default class SendInviteUsersMailMessage {
  /**
   * Sends invite mail to the given email.
   * @param user
   * @param invite
   */
  async sendInviteMail(tenantId: number, fromUser: ISystemUser, invite: any) {
    // Retreive tenant orgnaization name.
    const tenant = await Tenant.query()
      .findById(tenantId)
      .withGraphFetched('metadata');

    const root = path.join(global.__views_dir, '/images/ledger.png');

    const mail = new Mail()
      .setSubject(`${fromUser.firstName} has invited you to join a Ledger`)
      .setView('mail/UserInvite.html')
      .setTo(invite.email)
      .setAttachments([
        {
          filename: 'ledger.png',
          path: root,
          cid: 'ledger_logo',
        },
      ])
      .setData({
        root,
        acceptUrl: `${config.baseURL}/auth/invite/${invite.token}/accept`,
        fullName: `${fromUser.firstName} ${fromUser.lastName}`,
        firstName: fromUser.firstName,
        lastName: fromUser.lastName,
        email: fromUser.email,
        organizationName: tenant.metadata.name,
      });

    await mail.send();
  }
}
