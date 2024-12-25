// @ts-nocheck
import * as R from 'ramda';
import LedgerLoading from './LedgerLoading';
import withDashboard from '@/containers/Dashboard/withDashboard';

function SplashScreenComponent({ splashScreenLoading }) {
  return splashScreenLoading ? <LedgerLoading /> : null;
}

export const SplashScreen = R.compose(
  withDashboard(({ splashScreenLoading }) => ({
    splashScreenLoading,
  })),
)(SplashScreenComponent);
