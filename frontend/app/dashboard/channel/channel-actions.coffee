angular.module('supla-scripts').component 'channelActions',
  templateUrl: 'app/dashboard/channel/channel-actions.html'
  bindings:
    channel: '<'
    onAction: '&'
