require 'swagger_helper'

RSpec.describe 'api/v1/tasks', type: :request do
  path '/api/v1/tasks' do
    get('list tasks') do
      tags 'Tasks'
      produces 'application/json'
      parameter name: 'q[title_cont]', in: :query, type: :string, required: false, description: 'Filter by title containing text'
      parameter name: 'q[status_eq]', in: :query, type: :string, required: false, description: 'Filter by exact status match'

      response('200', 'successful') do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'Sample Task' },
              description: { type: :string, example: 'Task description' },
              status: { type: :string, example: 'initial' },
              delivery_date: { type: :string, format: :date, nullable: true, example: '2025-11-15' },
              created_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
              updated_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
              deleted_at: { type: :string, format: :datetime, nullable: true, example: nil }
            }
          }

        let!(:tasks) { create_list(:task, 3) }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
          expect(data.length).to eq(3)
        end
      end
    end

    post('create task') do
      tags 'Tasks'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :task_body, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string, example: 'New Task' },
              description: { type: :string, example: 'Task description' },
              status: { 
                type: :string, 
                enum: ['initial', 'in_progress', 'completed', 'cancelled', 'overdue'],
                example: 'initial'
              },
              delivery_date: { type: :string, format: :date, nullable: true, example: '2025-11-15' }
            },
            required: ['title', 'description', 'status']
          }
        },
        required: ['task']
      }

      response('201', 'created') do
        schema type: :object,
          properties: {
            id: { type: :integer, example: 1 },
            title: { type: :string, example: 'New Task' },
            description: { type: :string, example: 'Task description' },
            status: { type: :string, example: 'initial' },
            delivery_date: { type: :string, format: :date, nullable: true, example: '2025-11-15' },
            created_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
            updated_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
            deleted_at: { type: :string, format: :datetime, nullable: true, example: nil }
          }

        let(:task_body) do
          {
            task: {
              title: 'Sample Task',
              description: 'Sample description',
              status: 'initial'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq('Sample Task')
          expect(data['description']).to eq('Sample description')
          expect(data['status']).to eq('initial')
          expect(data['id']).to be_present
        end
      end

      response('422', 'unprocessable entity') do
        schema type: :object,
          properties: {
            title: { type: :array, items: { type: :string } },
            description: { type: :array, items: { type: :string } },
            status: { type: :array, items: { type: :string } }
          }

        let(:task_body) do
          {
            task: {
              title: '',
              description: '',
              status: ''
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('title')
          expect(data).to have_key('description')
          expect(data).to have_key('status')
        end
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Task ID'

    get('show task') do
      tags 'Tasks'
      produces 'application/json'

      response('200', 'successful') do
        schema type: :object,
          properties: {
            id: { type: :integer, example: 1 },
            title: { type: :string, example: 'Sample Task' },
            description: { type: :string, example: 'Task description' },
            status: { type: :string, example: 'initial' },
            delivery_date: { type: :string, format: :date, nullable: true, example: '2025-11-15' },
            created_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
            updated_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
            deleted_at: { type: :string, format: :datetime, nullable: true, example: nil }
          }

        let!(:task_record) { create(:task) }
        let(:id) { task_record.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(task_record.id)
          expect(data['title']).to eq(task_record.title)
          expect(data['description']).to eq(task_record.description)
          expect(data['status']).to eq(task_record.status)
        end
      end

      response('404', 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch('update task') do
      tags 'Tasks'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :task_body, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string, example: 'Updated Task' },
              description: { type: :string, example: 'Updated description' },
              status: { 
                type: :string, 
                enum: ['initial', 'in_progress', 'completed', 'cancelled', 'overdue'],
                example: 'in_progress'
              },
              delivery_date: { type: :string, format: :date, nullable: true, example: '2025-11-20' }
            }
          }
        },
        required: ['task']
      }

      response('200', 'successful') do
        schema type: :object,
          properties: {
            id: { type: :integer, example: 1 },
            title: { type: :string, example: 'Updated Task' },
            description: { type: :string, example: 'Updated description' },
            status: { type: :string, example: 'in_progress' },
            delivery_date: { type: :string, format: :date, nullable: true, example: '2025-11-20' },
            created_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
            updated_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
            deleted_at: { type: :string, format: :datetime, nullable: true, example: nil }
          }

        let!(:task_record) { create(:task) }
        let(:id) { task_record.id }
        let(:task_body) do
          {
            task: {
              title: 'Updated Task',
              description: 'Updated description'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq('Updated Task')
          expect(data['description']).to eq('Updated description')
          expect(data['id']).to eq(task_record.id)
        end
      end

      response('422', 'unprocessable entity') do
        let!(:task_record) { create(:task) }
        let(:id) { task_record.id }
        let(:task_body) do
          {
            task: {
              title: '',
              description: ''
            }
          }
        end
        run_test!
      end

      response('404', 'not found') do
        let(:id) { 'invalid' }
        let(:task_body) do
          {
            task: {
              title: 'Updated Task'
            }
          }
        end
        run_test!
      end
    end

    delete('delete task') do
      tags 'Tasks'
      produces 'application/json'

      response('200', 'successful') do
        schema type: :object,
          properties: {
            id: { type: :integer, example: 1 },
            title: { type: :string, example: 'Sample Task' },
            description: { type: :string, example: 'Task description' },
            status: { type: :string, example: 'cancelled' },
            delivery_date: { type: :string, format: :date, nullable: true, example: '2025-11-15' },
            created_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
            updated_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' },
            deleted_at: { type: :string, format: :datetime, example: '2025-11-04T10:00:00Z' }
          }

        let!(:task_record) { create(:task) }
        let(:id) { task_record.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(task_record.id)
          expect(data['status']).to eq('cancelled')
          expect(data['deleted_at']).to be_present
        end
      end

      response('404', 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end