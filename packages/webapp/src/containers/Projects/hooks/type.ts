// @ts-nocheck
const CUSTOMERS = {
  CUSTOMERS: 'CUSTOMERS',
  CUSTOMER: 'CUSTOMER',
};

const PROJECTS = {
  PROJECT: 'PROJECT',
  PROJECTS: 'PROJECTS',
};

const PROJECT_TASKS = {
  PROJECT_TASKS: 'PROJECT_TASKS',
  PROJECT_TASK: 'PROJECT_TASK',
};

const PROJECT_TIME_ENTRIES = {
  PROJECT_TIME_ENTRIES: 'PROJECT_TIME_ENTRIES',
  PROJECT_TIME_ENTRY: 'PROJECT_TIME_ENTRY',
};

const PROJECT_BILLABLE_ENTRIES = {
  PROJECT_BILLABLE_ENTRIES: 'PROJECT_BILLABLE_ENTRIES',
};

export default {
  ...PROJECTS,
  ...CUSTOMERS,
  ...PROJECT_TASKS,
  ...PROJECT_TIME_ENTRIES,
  ...PROJECT_BILLABLE_ENTRIES,
};
