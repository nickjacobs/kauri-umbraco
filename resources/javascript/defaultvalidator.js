function validator(){

}
validator.prototype = {
    validationData: null,
    applyFormValidation: function(data) {
        this.validationData = data;
        data.submitButton.click(this.submitClick);
        data.submitButton[0].validator = this;        
        var currentField;
        for (var i = 0; i < data.fields.length; i++) {
            currentField = data.fields[i];
            currentField.control[0].validator = this;
            if (currentField.type == "required") {
                currentField.control.blur(this.requiredBlur);
            }
            else if(currentField.type == "email"){
              currentField.type = "regex";
              currentField.expression = /^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/;
              currentField.control[0].regex = currentField.expression;
              currentField.control.blur(this.regexBlur);
            }
            else if (currentField.type == "regex") {
                currentField.control[0].regex = currentField.expression;
                currentField.control.blur(this.regexBlur);
            }
            if(currentField.dt){
                if(currentField.control.val() == '')
                    currentField.control.val(currentField.dt);
                currentField.control[0].defaultText = currentField.dt;
                currentField.control.focus(this.defaultFocus);
                currentField.control.blur(this.defaultBlur);
            }
        }
    },
    validate: function(vala) {
        var validationSummary = "";//"<p class='error'>";
        var currentField;
        var isValid = true;
        var val = null;
        for (var i = 0; i < vala.validationData.fields.length; i++) {
            currentField = vala.validationData.fields[i];
            val = currentField.control.val();
            if((currentField.type == "required") && (val == "" || (currentField.control[0].defaultText && (currentField.control[0].defaultText == val))) ){                
                   isValid = false;
                   validationSummary += currentField.msg /*+ "<br />"*/;
                   if(!currentField.control.parent().hasClass(vala.validationData.fieldErrorClass))
                    currentField.control.parent().addClass(vala.validationData.fieldErrorClass);
            }
            else if((currentField.type == "regex") && (!currentField.expression.test(val))){
               isValid = false;
               validationSummary += currentField.msg;   
               if(!currentField.control.parent().hasClass(vala.validationData.fieldErrorClass))
                currentField.control.parent().addClass(vala.validationData.fieldErrorClass);
            }
        }
        //validationSummary += "</p>";
        validationSummary += '<div class="clearer"></div>';
        if(isValid){
            vala.validationData.validationMessages.hide();
        }
        else{
            vala.validationData.validationMessages.html(validationSummary);
            vala.validationData.validationMessages.show();
        }        
        return isValid;
    },
    submitClick: function(e){
        var isValid = $(this)[0].validator.validate($(this)[0].validator);
        if(isValid)
            $(this)[0].validator.validationData.doPostback(this);
        else{
            e.preventDefault();
            return false;
        }
        
    },
    regexBlur: function() {
        var val = $(this).val();
        var expression = $(this)[0].regex;
        if (expression.test(val)) {
            $(this).parent().removeClass($(this)[0].validator.validationData.fieldErrorClass);
        }
        else {
            if(!$(this).parent().hasClass($(this)[0].validator.validationData.fieldErrorClass))
                $(this).parent().addClass($(this)[0].validator.validationData.fieldErrorClass);
        }
    },
    requiredBlur: function() {
        var val = $(this).val();
        if (val == "") {
            if(!$(this).parent().hasClass($(this)[0].validator.validationData.fieldErrorClass))
                $(this).parent().addClass($(this)[0].validator.validationData.fieldErrorClass);
        }
        else {
            $(this).parent().removeClass($(this)[0].validator.validationData.fieldErrorClass);
        }
    },
    defaultFocus: function(){
        var def = $(this)[0].defaultText;
        if(def == $(this).val()){
            $(this).val('');        
        }
    },
    defaultBlur: function(){
        if($(this).val() == '')
            $(this).val($(this)[0].defaultText);
    }
}