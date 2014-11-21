/** @jsx React.DOM */


var Mamajamas = Mamajamas || { Components: {} };

(function () {
  'use strict';

  Mamajamas.Components.ListDescription = React.createClass({

    getInitialState: function() {
      return {
        editing: false,
        error: false,
        errorMessage: null
      };
    },

    handleEdit: function() {
      this.setState({ editing: true });
    },

    handleCancel: function() {
      this.setState({ editing: false });
    },

    handleSave: function(attributes) {
      this.props.onSave(attributes,

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
    },

    render: function() {
      return (
        <div>
        <Mamajamas.Components.ListDescriptionView
          notes={this.props.model.get('notes')}
          onEdit={this.handleEdit}
          visible={!this.state.editing} />
        <Mamajamas.Components.ListDescriptionEdit
          notes={this.props.model.get('notes')}
          onCancel={this.handleCancel}
          onSave={this.handleSave}
          visible={this.state.editing} />
        </div>
      );
    }

  });

  Mamajamas.Components.ListDescriptionView = React.createClass({

    componentDidMount: function() {
      this.initExpandable();
    },

    componentDidUpdate: function() {
      this.initExpandable();
    },

    initExpandable: function() {
      // I don't love this jQuery interaction
      // make this native react
      if (this.props.visible) {
        $("div.expandable", ".module-notes").expander('destroy').expander({
          expandPrefix:     '... ',
          expandText:       'Expand', // default is 'read more'
          userCollapseText: 'Collapse',  // default is 'read less'
          expandEffect: 'show',
          expandSpeed: 0,
          collapseEffect: 'hide',
          collapseSpeed: 0,
          slicePoint: 265
        });
      }
    },

    render: function() {
      if (this.props.visible) {
        var content = null;
        if (this.props.notes) {
          content = (
            <p>
              {this.props.notes}
            </p>
          );
        } else {
          content = (
            <p className="light1">
              Add some details about yourself or registry (e.g., your feelings about becoming a parent, what types of products you like, etc.)
            </p>
          );
        }

        return (
          <div className="expandable editable">
            <span className="ss-icon ss-write icon-edit"
                  onClick={this.props.onEdit}>
            </span>
            {content}
          </div>
        );
      } else {
        return null;
      }
    }

  });

  Mamajamas.Components.ListDescriptionEdit = React.createClass({

    componentDidUpdate: function() {
      this.focusTextArea();
    },

    focusTextArea: function() {
      if (this.props.visible) {
        var field = this.refs.notesField.getDOMNode();
        field.focus();
        field.setSelectionRange(0, field.value.length);
      }
    },

    handleSave: function() {
      var notes = this.refs.notesField.getDOMNode().value.trim();
      this.props.onSave({
        notes: notes
      });
    },

    render: function() {
      var lblStyle = {
        display: 'none'
      };

      if (this.props.visible) {
        return (
          <div className="editing">
            <fieldset>
              <p>
                <span className="ss-icon ss-write icon-edit"></span>
                <label htmlFor="user_profile" style={lblStyle}>
                  Care to share a bit about yourself?
                </label>
                <br/>
                <textarea id="user_profile" name="user_profile"
                          ref="notesField"
                          defaultValue={this.props.notes}>
                </textarea>
              </p>
            </fieldset>
            <div className="progress-container">
              <button className="cancel-item button bt-light"
                      onClick={this.props.onCancel}
                      value="Reset" type="reset">
                Cancel
              </button>
              <button type="submit" value="Save"
                      onClick={this.handleSave}
                      className="button bt-color">
                Save
              </button>
            </div>
          </div>
        );
      } else {
        return null;
      }
    }

  });
})();
