// @ts-nocheck
import React from 'react';
import classNames from 'classnames';
import { Icon } from '@/components';

import '@/style/components/LedgerLoading.scss';

/**
 * Ledger logo loading.
 */
export default function LedgerLoading({ className }) {
  return (
    <div className={classNames('ledger-loading', className)}>
      <div class="center">
        <Icon icon="ledger" height={37} width={228} />
      </div>
    </div>
  );
}
