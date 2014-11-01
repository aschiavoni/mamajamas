/** @jsx React.DOM */


var Mamajamas = Mamajamas || { Components: {} };

(function () {
  'use strict';

  var ESCAPE_KEY = 27;
  var ENTER_KEY = 13;

  Mamajamas.Components.ListTitle = React.createClass({

    getInitialState: function() {
      return {
        editing: false,
        error: false
      };
    },

    handleEdit: function() {
      this.setState({ editing: true }, function(){
        var label = $(this.refs.listTitleLabel.getDOMNode());
        label.inFieldLabels(this.props.inFieldLabelDefaults);

        var field = this.refs.listTitleField.getDOMNode();
        field.focus();
        field.setSelectionRange(0, field.value.length);
      });
    },

    handleReset: function() {
      this.setState({ editing: false, error: false });
    },

    handleKeyDown: function (event) {
      if (event.which === ESCAPE_KEY) {
        this.handleReset();
      } else if (event.which === ENTER_KEY) {
        this.handleSave();
      }
    },

    handleSave: function() {
      var newTitle = this.refs.listTitleField.getDOMNode().value.trim();
      if (newTitle) {
        this.props.onSave({ title: newTitle },

                          function() {
                            this.setState({ editing: false, error: false });
                          }.bind(this),

                          function(errors) {
                            this.setState({
                              error: true,
                              errorMessage: errors.title
                            })
                          }.bind(this)

                         );
      } else {
        this.handleReset();
      }
    },

    render: function() {
      if (this.state.editing) {
        var lblStyle = {
          display: 'none',
          opacity: 0
        };

        var errStyle = { paddingTop: 10 };
        if (this.state.error)
          errStyle['display'] = 'block';
        else
          errStyle['display'] = 'none';

        return (
          <div className="editing">
            <fieldset>
              <p>
                <label ref="listTitleLabel" htmlFor="list_title"
                       style={lblStyle}>
                  Your baby gear registry title
                </label>
                <br/>
                <input type="text" ref="listTitleField" id="list_title"
                       size="30" autoComplete="off"
                       defaultValue={this.props.model.get('title')}
                       onKeyDown={this.handleKeyDown} />
                <button type="reset" value="Reset"
                        onClick={this.handleReset}
                        className="cancel button bt-light icon-link"
                        title="Cancel">Cancel</button>
                <button type="submit" value="Save"
                        onClick={this.handleSave}
                        className="save button bt-color icon-link"
                        name="commit"
                        title="Save changes">Save</button>
                <div className="error" style={errStyle}>
                  {this.state.errorMessage}
                </div>
              </p>
            </fieldset>
          </div>
        );
      } else {
        return (
          <div>
            <h2 className="editable" onClick={this.handleEdit}>
              {this.props.model.get('title')}&nbsp;
              <span className="ss-icon ss-write icon-edit"></span>
            </h2>
          </div>
        );
      }
    }

  });
})();
