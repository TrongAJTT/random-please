import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/view_models/list_picker_view_model.dart';
import 'package:random_please/widgets/common/step_indicator.dart';
import 'package:path/path.dart' as path;

class ImportFileWidget extends StatefulWidget {
  final ListPickerViewModel viewModel;
  final VoidCallback? onSuccess;
  final bool isEmbedded;

  const ImportFileWidget({
    super.key,
    required this.viewModel,
    this.onSuccess,
    this.isEmbedded = false,
  });

  @override
  State<ImportFileWidget> createState() => _ImportFileWidgetState();
}

class _ImportFileWidgetState extends State<ImportFileWidget> {
  int _currentStep = 0;
  bool _isImporting = false;
  bool _isDragging = false;
  bool _isProcessingFile = false;
  File? _selectedFile;
  List<String> _previewItems = [];
  String _listName = '';

  // Step 3 naming options
  bool _useManualName = true;
  int _selectedElementIndex = 1;
  bool _removeSelectedElement = false;

  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _elementIndexController = TextEditingController();

  AppLocalizations get loc => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _listNameController.dispose();
    _elementIndexController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        await _processFile(
            File(result.files.single.path!), result.files.single.name);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('${loc.importFileError}: $e');
      }
    }
  }

  Future<void> _processFile(File file, String fileName) async {
    setState(() {
      _isProcessingFile = true;
    });

    try {
      final content = await file.readAsString();

      // Parse file content into items
      List<String> items = content
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (items.isEmpty) {
        setState(() {
          _isProcessingFile = false;
        });
        if (mounted) {
          _showErrorDialog(loc.importEmptyFileError);
        }
        return;
      }

      // Check if file is large and show warning
      if (items.length > 200) {
        setState(() {
          _isProcessingFile = false;
        });

        final shouldContinue = await _showLargeFileWarning(items.length);
        if (!shouldContinue) {
          return;
        }

        setState(() {
          _isProcessingFile = true;
        });

        // Add small delay to show processing again
        await Future.delayed(const Duration(milliseconds: 100));
      }

      setState(() {
        _selectedFile = file;
        _previewItems = items;
        _listName = _getFileNameWithoutExtension(fileName);
        _listNameController.text = _listName;
        _elementIndexController.text = '1';
        _selectedElementIndex = 1;
        _currentStep = 1;
        _isProcessingFile = false;
      });
    } catch (e) {
      setState(() {
        _isProcessingFile = false;
      });
      if (mounted) {
        _showErrorDialog('${loc.importFileError}: $e');
      }
    }
  }

  String _getFileNameWithoutExtension(String fileName) {
    return fileName.split('.').first;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showLargeFileWarning(int itemCount) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.largeFileWarning),
        content: Text(loc.largeFileWarningMessage(itemCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.continueText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _goToNextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  bool get _canProceedFromStep3 {
    if (_useManualName) {
      return _listName.trim().isNotEmpty;
    } else {
      return _selectedElementIndex >= 1 &&
          _selectedElementIndex <= _previewItems.length;
    }
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        // Step 1: Can proceed only if file is selected and processed successfully
        return _selectedFile != null && _previewItems.isNotEmpty;
      case 1:
        // Step 2: Can proceed to confirmation step
        return true;
      case 2:
        // Step 3: Can proceed only if naming is valid
        return _canProceedFromStep3;
      default:
        return false;
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _performImport() async {
    if (_listName.trim().isEmpty || _previewItems.isEmpty) {
      return;
    }

    setState(() {
      _isImporting = true;
    });

    try {
      // Minimum loading time for better UX
      await Future.wait([
        _importData(),
        Future.delayed(const Duration(milliseconds: 1500)),
      ]);

      if (mounted) {
        // Show success and navigate back
        Navigator.of(context).pop();

        // Call success callback
        widget.onSuccess?.call();

        // Show success message
        SnackBarUtils.showTyped(
            context, loc.importSuccess, SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
        _showErrorDialog('${loc.importError}: $e');
      }
    }
  }

  Future<void> _importData() async {
    // Create a new list with the imported data
    widget.viewModel.createNewList(_listName.trim());

    // Prepare final items list
    List<String> finalItems = List.from(_previewItems);

    // Remove selected element if option is enabled
    if (!_useManualName &&
        _removeSelectedElement &&
        _selectedElementIndex > 0 &&
        _selectedElementIndex <= finalItems.length) {
      finalItems.removeAt(_selectedElementIndex - 1);
    }

    // Add all items to the newly created list
    await widget.viewModel.addBatchItems(finalItems);

    // Small delay for UX
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildStepIndicator() {
    final l10n = AppLocalizations.of(context)!;
    return StepIndicator(
      currentStep: _currentStep,
      stepLabels: [
        l10n.selectFile,
        l10n.preview,
        l10n.confirm,
      ],
      showCheckIcon: true,
      useContainer: false,
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildFileSelectionStep();
      case 1:
        return _buildPreviewStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildFileSelectionStep() {
    return Column(
      children: [
        // Drag and Drop Area
        Expanded(
          child: Stack(
            children: [
              DropTarget(
                onDragDone: (detail) async {
                  final files = detail.files
                      .where((file) => file.path.toLowerCase().endsWith('.txt'))
                      .toList();

                  if (files.isNotEmpty) {
                    final file = File(files.first.path);
                    await _processFile(file, path.basename(files.first.path));
                  } else {
                    _showErrorDialog('Please select a .txt file');
                  }
                },
                onDragEntered: (detail) {
                  setState(() {
                    _isDragging = true;
                  });
                },
                onDragExited: (detail) {
                  setState(() {
                    _isDragging = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isDragging
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: _isDragging
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1)
                        : Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isDragging ? Icons.file_download : Icons.upload_file,
                        size: 64,
                        color: _isDragging
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isDragging ? loc.dragDropHint : loc.selectFileToImport,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: _isDragging
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.supportedFormat,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _isProcessingFile ? null : _pickFile,
                        icon: const Icon(Icons.folder_open, size: 20),
                        label: Text(loc.selectFile),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          minimumSize: const Size(200, 48),
                          textStyle:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        loc.dragDropHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.8),
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // Processing overlay
              if (_isProcessingFile)
                Container(
                  color: Theme.of(context)
                      .colorScheme
                      .scrim
                      .withValues(alpha: 0.5),
                  child: Center(
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              loc.processingFile,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewStep() {
    final theme = Theme.of(context);

    return Column(
      children: [
        // File info header - compact horizontal layout
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color:
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: .2),
              width: 1,
            ),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.description,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedFile != null
                          ? path.basename(_selectedFile!.path)
                          : '',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_previewItems.length} ${loc.items}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_previewItems.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Items list - compact grid layout
        Expanded(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      loc.preview,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              theme.colorScheme.primary.withValues(alpha: .3),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        '${_previewItems.length} ${loc.items}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: _previewItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: .35),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: .25),
                            width: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .03),
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: .35),
                                  width: 1.2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationStep() {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 16),
        // Name input form - compact layout
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Naming options header
                Row(
                  children: [
                    Icon(
                      Icons.edit_note,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loc.listNamingOptions,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Compact radio options
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: .2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Option 1: Manual name
                      RadioListTile<bool>(
                        title: Text(
                          loc.enterManually,
                          style: theme.textTheme.bodyMedium,
                        ),
                        value: true,
                        groupValue: _useManualName,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _useManualName = value;
                              if (value) {
                                // Reset to manual name when switching to manual mode
                                _listName = _listNameController.text.trim();
                              }
                            });
                          }
                        },
                      ),
                      if (_useManualName) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: TextFormField(
                            controller: _listNameController,
                            decoration: InputDecoration(
                              labelText: loc.listName,
                              hintText: _selectedFile != null
                                  ? path.basenameWithoutExtension(
                                      _selectedFile!.path)
                                  : '',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.list, size: 20),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              setState(() {
                                _listName = value;
                              });
                            },
                          ),
                        ),
                      ],
                      // Option 2: Use element as name
                      RadioListTile<bool>(
                        title: Text(
                          loc.useElementAsName,
                          style: theme.textTheme.bodyMedium,
                        ),
                        value: false,
                        groupValue: _useManualName,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _useManualName = value;
                              if (!value) {
                                // Update list name based on selected element when switching to element mode
                                if (_selectedElementIndex >= 1 &&
                                    _selectedElementIndex <=
                                        _previewItems.length) {
                                  _listName =
                                      _previewItems[_selectedElementIndex - 1];
                                }
                              }
                            });
                          }
                        },
                      ),
                      if (!_useManualName) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: TextFormField(
                            controller: _elementIndexController,
                            decoration: InputDecoration(
                              labelText:
                                  '${loc.elementNumber} (1-${_previewItems.length})',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.numbers, size: 20),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              final index = int.tryParse(value);
                              if (index != null &&
                                  index >= 1 &&
                                  index <= _previewItems.length) {
                                setState(() {
                                  _selectedElementIndex = index;
                                  _listName = _previewItems[index - 1];
                                });
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: CheckboxListTile(
                            title: Text(
                              loc.removeElementFromList,
                              style: theme.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              loc.removeElementDescription,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            value: _removeSelectedElement,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              setState(() {
                                _removeSelectedElement = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Compact preview section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: .2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Table header
                      Row(
                        children: [
                          Icon(
                            Icons.preview,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            loc.listPreview,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Table structure
                      Column(
                        children: [
                          // Table rows - List Name row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: .2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                              border: Border.all(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: .15),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    loc.listName,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _listName.isNotEmpty
                                        ? _listName
                                        : loc.noNameSet,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Item Count row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: .2),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                              border: Border.all(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: .15),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.numbers,
                                  size: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    loc.itemCount,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${_getFinalItemCount()}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _getFinalItemCount() {
    if (!_useManualName && _removeSelectedElement) {
      return _previewItems.length - 1;
    }
    return _previewItems.length;
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        if (_currentStep > 0)
          TextButton.icon(
            onPressed: _isImporting ? null : _goToPreviousStep,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: Text(loc.back),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          )
        else
          const SizedBox(),

        // Next/Import button
        ElevatedButton.icon(
          onPressed: _isImporting
              ? null
              : _canProceedToNextStep()
                  ? () {
                      if (_currentStep == 2) {
                        if (_canProceedFromStep3) {
                          _performImport();
                        }
                      } else {
                        _goToNextStep();
                      }
                    }
                  : null,
          icon: _isImporting
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary),
                  ),
                )
              : Icon(_currentStep == 2 ? Icons.download : Icons.arrow_forward,
                  size: 18),
          label: Text(_currentStep == 2
              ? (_isImporting ? loc.importing : loc.importData)
              : loc.next),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: widget.isEmbedded
              ? null
              : AppBar(
                  title: Text(loc.importFromFile),
                  centerTitle: true,
                ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildStepIndicator(),
                const SizedBox(height: 0),
                Expanded(
                  child: _buildStepContent(),
                ),
                const SizedBox(height: 12),
                _buildActionButtons(),
              ],
            ),
          ),
        ),

        // Loading overlay
        if (_isImporting)
          Container(
            color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.importing,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.pleaseWait,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
