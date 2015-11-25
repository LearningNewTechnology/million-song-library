import _ from 'lodash';
/**
 * login page main controller
 * @param {$rootScope.Scope} $scope
 * @param {ui.router.state.$state} $state
 * @param {authorisation} authorisation
 */
export default class loginCtrl {
  /*@ngInject*/

  /**
   * user form submit action
   */

  constructor($scope, authorisation, $state) {
    this.isPasswordCompliant = true;
    this.submit = async() => {
      delete this.hasError;
      try {
        await authorisation.authorise(this.email, this.password);
        // if authorisation is success then redirect user to home page
        $state.go('msl.home');
      } catch(e) {
        this.hasError = true;
        $scope.$evalAsync();
      }
    };
  }

  /**
   * Checks if password is compliant with security patterns
   * @returns {boolean}
   */
  checkIfPasswordCompliant() {
    if(angular.isDefined(this.password)) {
      let passwordRules = [
        /\w*[\d]+\w*/,
        /\w*[A-Z]+\w*/,
        /\w*[!#$%&*+,./:;<=>?@\^_~-]+\w*/,
      ];
      this.isPasswordCompliant = _.all(passwordRules, (rule) => rule.test(this.password));
    }
  }

}
